import http.server, os, urllib.parse
ROOT = os.path.dirname(os.path.abspath(__file__))
os.makedirs(os.path.join(ROOT, 'caps'), exist_ok=True)
class H(http.server.SimpleHTTPRequestHandler):
    def __init__(s,*a,**k): super().__init__(*a, directory=ROOT, **k)
    def do_POST(s):
        q = urllib.parse.parse_qs(urllib.parse.urlparse(s.path).query)
        name = os.path.basename(q.get('name',['cap.png'])[0]) or 'cap.png'
        n = int(s.headers.get('Content-Length',0)); data = s.rfile.read(n)
        p = os.path.join(ROOT,'caps',name); base, ext = os.path.splitext(p); i=1
        while os.path.exists(p): p = f"{base}_{i}{ext}"; i+=1
        open(p,'wb').write(data); s.send_response(200); s.end_headers(); s.wfile.write(os.path.basename(p).encode())
http.server.ThreadingHTTPServer(('127.0.0.1',8765),H).serve_forever()
