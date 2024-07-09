from flask import Flask, jsonify


app = Flask(__name__)

@app.route('/chat')
def chatResponse():
    app.logger.info("Chat endpoint called")
    return "Hello World!"


@app.route('/healthcheck')
def ping():
    app.logger.info("Healthcheck endpoint called")
    return jsonify({"status": "healthy"}), 200

if __name__ =='__main__':
    app.run()

