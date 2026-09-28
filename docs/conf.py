# Configuration file for the Sphinx documentation builder.
# -- Project information
project = "gigi"
copyright = "2026, Kazuya Takei"
author = "Kazuya Takei"
release = "0.3.0"

# -- General configuration
extensions = [
    # Third-party extensions
    "myst_parser",
]
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

# -- Options for HTML output
html_theme = "alabaster"
html_static_path = ["_static"]
