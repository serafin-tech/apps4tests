from flask import Flask, render_template, url_for, session, abort, redirect
from authlib.integrations.flask_client import OAuth
import json
from urllib.parse import quote_plus, urlencode

app = Flask(__name__)

# Both internal (server-side) and external (browser-side) Keycloak URLs are
# the same because both services run on the host network.
KEYCLOAK_URL = "http://localhost:8080/realms/myorg"

appConf = {
    "OAUTH2_CLIENT_ID": "test_web_app",
    "OAUTH2_CLIENT_SECRET": "FXv2ugPyXsF2hN46EoAL3bmvx5MiUdHf",
    "OAUTH2_ISSUER": KEYCLOAK_URL,
    "FLASK_SECRET": "ALongRandomlyGeneratedString",
    "FLASK_PORT": 5000
}

app.secret_key = appConf["FLASK_SECRET"]

oauth = OAuth(app)
oauth.register(
    "myApp",
    client_id=appConf["OAUTH2_CLIENT_ID"],
    client_secret=appConf["OAUTH2_CLIENT_SECRET"],
    client_kwargs={
        "scope": "openid profile email",
        "code_challenge_method": "S256",  # PKCE
    },
    server_metadata_url=f'{appConf["OAUTH2_ISSUER"]}/.well-known/openid-configuration',
)


@app.route("/")
def home():
    return render_template(
        "index.html",
        session=session.get("user"),
        pretty=json.dumps(session.get("user"), indent=4),
    )


@app.route("/login")
def login():
    if "user" in session:
        abort(404)
    return oauth.myApp.authorize_redirect(redirect_uri=url_for("callback", _external=True))


@app.route("/logout")
def logout():
    id_token = session["user"]["id_token"]
    session.clear()
    return redirect(
        appConf["OAUTH2_ISSUER"]
        + "/protocol/openid-connect/logout?"
        + urlencode(
            {
                "post_logout_redirect_uri": url_for("loggedout", _external=True),
                "id_token_hint": id_token,
            },
            quote_via=quote_plus,
        )
    )


@app.route("/loggedout")
def loggedout():
    if "user" in session:
        abort(404)
    return redirect(url_for("home"))


@app.route("/callback")
def callback():
    token = oauth.myApp.authorize_access_token()
    session["user"] = token
    return redirect(url_for("home"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=appConf["FLASK_PORT"], debug=True)
