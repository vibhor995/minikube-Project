from flask import Flask, jsonify, Response
import time

app = Flask(__name__)

# Global variables to keep track of the status
ping_status = 0
readiness_status = 1
health_status = 1
last_ping_time = time.time()

@app.route('/ping', methods=['GET'])
def ping():
    global ping_status, last_ping_time
    ping_status = 1  # Set status to 1 to indicate success
    last_ping_time = time.time()
    return "pong", 200

@app.route('/metrics', methods=['GET'])
def metrics():
    global ping_status, readiness_status, health_status, last_ping_time

    metrics_data = f"""# HELP ping_status The status of the ping endpoint
# TYPE ping_status gauge
ping_status {ping_status}
# HELP readiness_status The readiness status of the application
# TYPE readiness_status gauge
readiness_status {readiness_status}
# HELP health_status The health status of the application
# TYPE health_status gauge
health_status {health_status}
# HELP ping_last_call The timestamp of the last call to the ping endpoint
# TYPE ping_last_call gauge
ping_last_call {last_ping_time}
"""
    return Response(metrics_data, mimetype='text/plain')

@app.route('/ready', methods=['GET'])
def readiness_check():
    global readiness_status
    readiness_status = 1  # Set readiness status to 1 (ready)
    return jsonify(status="ready"), 200

@app.route('/healthz', methods=['GET'])
def health_check():
    global health_status
    health_status = 1  # Set health status to 1 (healthy)
    return jsonify(status="ok"), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

