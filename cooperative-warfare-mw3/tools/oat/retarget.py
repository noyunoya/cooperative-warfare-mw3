"""Rebind a body GLB onto the Army skeleton (84 joints) so every Army player anim fits.
usage: retarget.py <ref_army.glb> <in.glb> <out.glb>"""
import json,struct,sys,copy
def load(p):
    d=open(p,'rb').read(); l=struct.unpack('<I',d[12:16])[0]; j=json.loads(d[20:20+l])
    o=20+l; bl=struct.unpack('<I',d[o:o+4])[0]; return j,bytearray(d[o+8:o+8+bl])
def save(p,j,b):
    while len(b)%4: b.append(0)
    j['buffers'][0]['byteLength']=len(b)
    js=json.dumps(j,separators=(',',':')).encode()
    while len(js)%4: js+=b' '
    tot=12+8+len(js)+8+len(b)
    open(p,'wb').write(struct.pack('<III',0x46546C67,2,tot)+struct.pack('<II',len(js),0x4E4F534A)+js+struct.pack('<II',len(b),0x004E4942)+bytes(b))
ref,ref_b=load(sys.argv[1]); t,tb=load(sys.argv[2])
rn=ref['nodes']; tn=t['nodes']
rs=ref['skins'][0]; ts=t['skins'][0]
a_idx={rn[n]['name']:k for k,n in enumerate(rs['joints'])}
par={}
for i,n in enumerate(tn):
    for c in n.get('children',[]): par[c]=i
def tomap(node):
    x=node
    while x is not None:
        nm=tn[x]['name']
        if nm in a_idx: return a_idx[nm]
        x=par.get(x)
    return 0
jmap=[tomap(n) for n in ts['joints']]
moved=[(tn[n]['name'],rn[rs['joints'][jmap[k]]]['name']) for k,n in enumerate(ts['joints']) if tn[n]['name'] not in a_idx]
# remap skin weights
done=set()
for m in t['meshes']:
    for pr in m['primitives']:
        ja=t['accessors'][pr['attributes']['JOINTS_0']]; wa=t['accessors'][pr['attributes']['WEIGHTS_0']]
        assert ja['componentType']==5121 and wa['componentType']==5126
        jb=t['bufferViews'][ja['bufferView']]; wb=t['bufferViews'][wa['bufferView']]
        jo=jb.get('byteOffset',0)+ja.get('byteOffset',0); wo=wb.get('byteOffset',0)+wa.get('byteOffset',0)
        if (jo,wo) in done: continue
        done.add((jo,wo))
        for v in range(ja['count']):
            js=list(tb[jo+v*4:jo+v*4+4]); ws=list(struct.unpack_from('<4f',tb,wo+v*16))
            acc={}
            for j_,w_ in zip(js,ws):
                if w_>0: acc[jmap[j_]]=acc.get(jmap[j_],0)+w_
            items=sorted(acc.items(),key=lambda x:-x[1])[:4]
            ns=[i for i,_ in items]+[0]*(4-len(items)); nw=[w for _,w in items]+[0.0]*(4-len(items))
            tot=sum(nw) or 1.0; nw=[w/tot*sum(ws) if sum(ws)>0 else w for w in nw]
            tb[jo+v*4:jo+v*4+4]=bytes(ns); struct.pack_into('<4f',tb,wo+v*16,*nw)
# new nodes: Army joint nodes + t's mesh nodes + root
newn=copy.deepcopy(rn[:len(rs['joints'])])
mesh_old=[i for i,n in enumerate(tn) if 'mesh' in n]
root_old=t['scenes'][0]['nodes'][0]
base=len(newn); mp={o:base+k for k,o in enumerate(mesh_old)}
for o in mesh_old: newn.append(copy.deepcopy(tn[o]))
rootnode=copy.deepcopy(tn[root_old]); rootnode['children']=[mp[c] if c in mp else 0 for c in tn[root_old]['children']]
# ensure tag_origin child present once
newn.append(rootnode); newroot=len(newn)-1
t['nodes']=newn; t['scenes'][0]['nodes']=[newroot]
# skin: army joints + army IBM appended
ra=ref['accessors'][rs['inverseBindMatrices']]; rb=ref['bufferViews'][ra['bufferView']]
ro=rb.get('byteOffset',0)+ra.get('byteOffset',0); data=ref_b[ro:ro+ra['count']*64]
while len(tb)%4: tb.append(0)
off=len(tb); tb+=data
t['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':len(data)})
ta=t['accessors'][ts['inverseBindMatrices']]; ta['bufferView']=len(t['bufferViews'])-1; ta['byteOffset']=0; ta['count']=ra['count']
ts['joints']=list(rs['joints']); ts['skeleton']=rs.get('skeleton',0)
save(sys.argv[3],t,tb)
print(sys.argv[2].split('/')[-1],'extra bones merged:',len(moved),'e.g.',moved[:6])
