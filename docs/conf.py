from sphinx.util.osutil import make_filename_from_project


# -- Project information ---------------
project = "GIGI"
copyright = "2021, Kazuya Takei"
author = "Kazuya Takei"
release = "0.2.1"

# -- General configuration -------------
extensions = []
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

# -- Options for HTML output -----------
html_theme = "agogo"
html_static_path = ["_static"]

# -- Options for MAN output ------------
man_pages = [
    (
        "manual",
        make_filename_from_project(project),
        f"{project} {release}",
        [
            author,
        ],
        1,
    ),
]
