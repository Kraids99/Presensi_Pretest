import threading
import webbrowser
from api.app import app

def start_flask():
    app.run(port=5000)

if __name__ == '__main__':
    t = threading.Thread(target=start_flask, daemon=True)
    t.start()
    webbrowser.open("http://127.0.0.1:5000")
