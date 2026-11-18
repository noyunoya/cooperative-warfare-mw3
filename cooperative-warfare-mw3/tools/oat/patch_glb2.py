import sys,os
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from patch_glb import read,write,accdata,idx,parents
def patch2(src,dst,ref):
    rj,rb=ref; j,b=read(src)
    rn=idx(rj); rp=parents(rj); n=idx(j)
    rsk=rj['skins'][0]; rjn=[rj['nodes'][i]['name'] for i in rsk['joints']]
    ribm=accdata(rj,rb,rsk['inverseBindMatrices'])
    sk=j['skins'][0]; have={j['nodes'][i]['name'] for i in sk['joints']}
    ibm=bytearray(accdata(j,b,sk['inverseBindMatrices']))
    added=[]
    todo=[x for x in rjn if x not in have and not x.startswith('surf')]
    for _ in range(4):
        for name in list(todo):
            par=rj['nodes'][rp[rn[name]]]['name'] if rn[name] in rp else None
            if par is None or par not in n: continue
            rnode=rj['nodes'][rn[name]]; nn={'name':name}
            for k in('translation','rotation','scale'):
                if k in rnode: nn[k]=rnode[k]
            j['nodes'].append(nn); n[name]=len(j['nodes'])-1
            j['nodes'][n[par]].setdefault('children',[]).append(n[name])
            sk['joints'].append(n[name]); k=rjn.index(name); ibm+=ribm[k*64:(k+1)*64]
            added.append(name); todo.remove(name)
    while len(b)%4: b.append(0)
    off=len(b); b+=ibm
    j['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':len(ibm)})
    j['accessors'].append({'bufferView':len(j['bufferViews'])-1,'componentType':5126,'count':len(sk['joints']),'type':'MAT4'})
    sk['inverseBindMatrices']=len(j['accessors'])-1
    j['buffers'][0]['byteLength']=len(b)
    write(dst,j,b); return added,todo
if __name__=='__main__':
    ref=read(sys.argv[1])
    for src,dst in zip(sys.argv[2::2],sys.argv[3::2]):
        print(os.path.basename(dst),patch2(src,dst,ref))
