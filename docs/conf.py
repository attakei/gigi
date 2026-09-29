# Configuration file for the Sphinx documentation builder.
from pygments.lexer import RegexLexer, bygroups
from pygments.token import Comment, Keyword, Name, Operator, Punctuation, String, Text

# -- Project information
project = "gigi"
copyright = "2026, Kazuya Takei"
author = "Kazuya Takei"
release = "0.3.0"

# -- General configuration
extensions = [
    # Core-bundled extensions
    "sphinx.ext.todo",
    # Third-party extensions
    "myst_parser",
]
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

# -- Options for HTML output
html_theme = "bulma-basic"
html_static_path = ["_static"]


class GitIgnoreLexer(RegexLexer):
    """Pygments Lexer for .gitignore files."""

    name = "gitignore"
    aliases = ["gitignore", "ignore"]
    filenames = [".gitignore", ".dockerignore", ".helmignore"]

    tokens = {
        "root": [
            (r"^#.*$", Comment.Single),
            (r"!", Keyword),
            (r"\*+", Operator),
            (r"/", Punctuation),
            (r"[^#!\*/\s]+", Name.Variable),
            (r"\s+", Text),
        ]
    }


def setup(app):
    app.add_lexer("gitignore", GitIgnoreLexer)
