import sys,os,struct
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from patch_glb import read,write,accdata,idx,parents
def reorder(src,dst,ref):
    rj,rb=ref; j,b=read(src)
    rsk=rj['skins'][0]; rorder=[rj['nodes'][i]['name'] for i in rsk['joints']]
    sk=j['skins'][0]; names=[j['nodes'][i]['name'] for i in sk['joints']]
    nodeidx={j['nodes'][i]['name']:i for i in sk['joints']}
    ibm_old=accdata(j,b,sk['inverseBindMatrices'])
    # new order: ref order (present) then leftovers (keep relative order)
    new=[x for x in rorder if x in names]+[x for x in names if x not in rorder]
    # parent-before-child check
    par=parents(j); pos={x:i for i,x in enumerate(new)}
    bad=[]
    for x in new:
        p=par.get(nodeidx[x])
        if p is not None and j['nodes'][p].get('name') in pos and pos[j['nodes'][p]['name']]>pos[x]: bad.append(x)
    old_pos={x:i for i,x in enumerate(names)}
    remap=[pos[n] for n in names]          # old index -> new index
    # remap vertex joints
    seen=set()
    for m in j['meshes']:
        for pr in m['primitives']:
            ai=pr['attributes'].get('JOINTS_0')
            if ai is None or ai in seen: continue
            seen.add(ai); a=j['accessors'][ai]; bv=j['bufferViews'][a['bufferView']]
            ct=a['componentType']; sz={5121:1,5123:2}[ct]; fmt='<'+('B' if sz==1 else 'H')
            start=bv.get('byteOffset',0)+a.get('byteOffset',0); stride=bv.get('byteStride') or sz*4
            for v in range(a['count']):
                for c in range(4):
                    o=start+v*stride+c*sz; val=struct.unpack_from(fmt,b,o)[0]
                    struct.pack_into(fmt,b,o,remap[val])
    ibm=bytearray()
    for x in new: k=old_pos[x]; ibm+=ibm_old[k*64:(k+1)*64]
    sk['joints']=[nodeidx[x] for x in new]
    while len(b)%4: b.append(0)
    off=len(b); b+=ibm
    j['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':len(ibm)})
    j['accessors'].append({'bufferView':len(j['bufferViews'])-1,'componentType':5126,'count':len(new),'type':'MAT4'})
    sk['inverseBindMatrices']=len(j['accessors'])-1
    j['buffers'][0]['byteLength']=len(b)
    write(dst,j,b); return len(new),bad
if __name__=='__main__':
    ref=read(sys.argv[1])
    for src,dst in zip(sys.argv[2::2],sys.argv[3::2]): print(os.path.basename(dst),reorder(src,dst,ref))
