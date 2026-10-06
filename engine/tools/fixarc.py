import re, sys
num = re.compile(r'[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?')
def fix_d(d):
    out=[]; i=0; cmd=None; n=len(d)
    while i<n:
        c=d[i]
        if c.isalpha():
            cmd=c; out.append(c); i+=1; continue
        if c in ' ,\n\t': i+=1; continue
        if cmd in 'aA':
            vals=[]
            for k in range(7):
                while i<n and d[i] in ' ,': i+=1
                if k in (3,4):
                    vals.append(d[i]); i+=1
                else:
                    m=num.match(d,i); vals.append(m.group()); i=m.end()
            out.append(' '+' '.join(vals)+' ')
        else:
            m=num.match(d,i)
            if not m: raise SystemExit('bad at %d %r'%(i,d[i:i+20]))
            out.append(' '+m.group()); i=m.end()
    return ''.join(out)
s=open(sys.argv[1]).read()
s=re.sub(r'(\sd=")([^"]*)(")', lambda m: m.group(1)+fix_d(m.group(2))+m.group(3), s)
open(sys.argv[2],'w').write(s)
