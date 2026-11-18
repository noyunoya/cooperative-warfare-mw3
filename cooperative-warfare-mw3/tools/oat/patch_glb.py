import json,struct,sys,copy,os
NEW=['pelvis','torso_stabilizer','back_low','back_mid']
def read(p):
    b=open(p,'rb').read(); l=struct.unpack('<I',b[12:16])[0]
    j=json.loads(b[20:20+l]); off=20+l
    bl=struct.unpack('<I',b[off:off+4])[0]; return j,bytearray(b[off+8:off+8+bl])
def write(p,j,binc):
    while len(binc)%4: binc.append(0)
    js=json.dumps(j,separators=(',',':')).encode()
    while len(js)%4: js+=b' '
    tot=12+8+len(js)+8+len(binc)
    open(p,'wb').write(b'glTF'+struct.pack('<II',2,tot)+struct.pack('<I',len(js))+b'JSON'+js+struct.pack('<I',len(binc))+b'BIN\0'+bytes(binc))
def accdata(j,b,ai):
    a=j['accessors'][ai]; bv=j['bufferViews'][a['bufferView']]
    s=bv.get('byteOffset',0)+a.get('byteOffset',0); return bytes(b[s:s+a['count']*64])
def idx(j): return {n['name']:i for i,n in enumerate(j['nodes']) if 'name' in n}
def parents(j):
    p={}
    for i,n in enumerate(j['nodes']):
        for c in n.get('children',[]): p[c]=i
    return p
def patch(src,dst,ref):
    rj,rb=ref; j,b=read(src); 
    rn=idx(rj); rp=parents(rj); n=idx(j); p=parents(j)
    rsk=rj['skins'][0]; rjn=[rj['nodes'][i]['name'] for i in rsk['joints']]
    ribm=accdata(rj,rb,rsk['inverseBindMatrices'])
    added=[]
    # 1. create missing nodes (copy TRS from ref)
    for name in NEW:
        if name in n: continue
        rnode=rj['nodes'][rn[name]]; nn={'name':name}
        for k in('translation','rotation','scale'):
            if k in rnode: nn[k]=rnode[k]
        j['nodes'].append(nn); n[name]=len(j['nodes'])-1; added.append(name)
    # 2. reparent to match ref hierarchy for the chain around the new bones
    touched=set(NEW)
    for name in NEW: touched|={rj['nodes'][c]['name'] for c in rj['nodes'][rn[name]].get('children',[])}
    for name in touched:
        if name not in n or name not in rn: continue
        want=rj['nodes'][rp[rn[name]]]['name']
        if want not in n: continue
        cur=p.get(n[name])
        if cur is not None and j['nodes'][cur]['name']==want: continue
        if cur is not None: j['nodes'][cur]['children'].remove(n[name])
        j['nodes'][n[want]].setdefault('children',[]).append(n[name]); p[n[name]]=n[want]
        rnode=rj['nodes'][rn[name]]            # take ref local TRS (world poses are identical)
        for k in('translation','rotation','scale'):
            if k in rnode: j['nodes'][n[name]][k]=rnode[k]
            else: j['nodes'][n[name]].pop(k,None)
    # 2b. match ref local transform for stowed-weapon tags (attachment points)
    for name in ('tag_stowed_back','tag_stowed_hip_rear','tag_stowed_hip_le','tag_stowed_hip_ri'):
        if name in n and name in rn:
            rnode=rj['nodes'][rn[name]]
            for k in('translation','rotation','scale'):
                if k in rnode: j['nodes'][n[name]][k]=rnode[k]
    # 3. skin: append joints + their inverse bind matrices
    sk=j['skins'][0]; ibm=bytearray(accdata(j,b,sk['inverseBindMatrices']))
    have={j['nodes'][i]['name'] for i in sk['joints']}
    for name in NEW:
        if name in have: continue
        sk['joints'].append(n[name]); k=rjn.index(name); ibm+=ribm[k*64:(k+1)*64]
    # new bufferView/accessor at end of the bin chunk
    while len(b)%4: b.append(0)
    off=len(b); b+=ibm
    j['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':len(ibm)})
    j['accessors'].append({'bufferView':len(j['bufferViews'])-1,'componentType':5126,'count':len(sk['joints']),'type':'MAT4'})
    sk['inverseBindMatrices']=len(j['accessors'])-1
    j['buffers'][0]['byteLength']=len(b)
    write(dst,j,b); return added
if __name__=='__main__':
    ref=read(sys.argv[1])
    for src,dst in zip(sys.argv[2::2],sys.argv[3::2]):
        print(os.path.basename(dst),'added',patch(src,dst,ref))
