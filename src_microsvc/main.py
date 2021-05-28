from flask import Flask, jsonify
import hashlib

app = Flask(__name__)


@app.route("/md5/<string:strname>", methods=['GET'])
def conv_md5(strname):
    hash_obj =hashlib.md5(strname.encode())
    result = {
    "hash": "md5",
    "cleartext": strname,
    "hashedtext": hash_obj.hexdigest()
    }
    result = jsonify(result)
    # Returns JSON
    return result


@app.route("/sha256/<string:strname>", methods=['GET'])
def conv_sha256(strname):
    hash_obj =hashlib.sha256(strname.encode())
    result = {
    "hash": "sha256",
    "cleartext": strname,
    "hashedtext": hash_obj.hexdigest()
    }
    result = jsonify(result)
    # Returns JSON
    return result


# Checks to see if the name of the package is the run as the main package.
if __name__ == "__main__":
    # Runs the Flask application only if the main.py file is being run.
    app.run(host='0.0.0.0')