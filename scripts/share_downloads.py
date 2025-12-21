import http.server
import socketserver
import os
from pathlib import Path

# Configuration
PORT = 8000
DOWNLOAD_DIR = str(Path.home() / "Downloads")
# Alternative: Specify exact path
# DOWNLOAD_DIR = "/path/to/your/downloads"


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DOWNLOAD_DIR, **kwargs)

    def log_message(self, format, *args):
        # Custom logging to see access
        print(
            f"{self.client_address[0]} - {self.log_date_time_string()} - {format%args}"
        )


# Get local IP address for sharing
import socket


def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("10.255.255.255", 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip


if __name__ == "__main__":
    local_ip = get_local_ip()

    print(f"Sharing directory: {DOWNLOAD_DIR}")
    print(f"Local URL: http://localhost:{PORT}")
    print(f"Network URL: http://{local_ip}:{PORT}")
    print("Press Ctrl+C to stop the server\n")

    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped")
