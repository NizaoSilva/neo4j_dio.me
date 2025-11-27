from flask import Flask, request, render_template_string
from neo4j import GraphDatabase

app = Flask(__name__)

URI = "neo4j+s://cec8b136.databases.neo4j.io"
USER = "neo4j"
PASSWORD = "6Yde_j7mDgTB5jOR8WoFaZjWcxy1dhXMA2sqXeLmhmw"

driver = GraphDatabase.driver(URI, auth=(USER, PASSWORD))

html_form = """
<!DOCTYPE html>
<html>
<head><title>Cadastro</title></head>
<body>
    <h2>Cadastro de Usuário</h2>
    <form method="POST" action="/cadastro">
        Nome: <input type="text" name="nome" required><br><br>
        Email: <input type="email" name="email" required><br><br>
        <input type="submit" value="Cadastrar">
    </form>
    {% if mensagem %}
        <p><strong>{{ mensagem }}</strong></p>
    {% endif %}
</body>
</html>
"""

@app.route("/", methods=["GET"])
def index():
    return render_template_string(html_form)

@app.route("/cadastro", methods=["POST"])
def cadastrar():
    nome = request.form.get("nome")
    email = request.form.get("email")
    id_gerado = int.from_bytes(email.encode(), "little") % 10000

    def inserir(tx):
        query = """
        MERGE (u:Usuario {email: $email})
        ON CREATE SET u.nome = $nome, u.id = $id
        RETURN u.nome AS nome, u.email AS email, u.id AS id
        """
        result = tx.run(query, nome=nome, email=email, id=id_gerado)
        return result.single().data()

    with driver.session() as session:
        usuario = session.execute_write(inserir)

    return render_template_string(html_form, mensagem=f"Usuário {usuario['nome']} cadastrado com sucesso!")

if __name__ == "__main__":
    app.run(debug=True)