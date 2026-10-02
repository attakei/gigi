==========
``create``
==========

``create`` subcommand creates ``.gitignore`` file from workspace by arguments.

Details
=======

.. todo:: It will writes here after.

See :doc:`../spec/format` to know about format of generating files.

Usage
=====

.. code:: console

   gigi create [OPTIONS] ARGUMENTS

``ARGUMENTS`` are source names that it can detect from buckets.

Options
=======

--dest
  Destination path to generate Gitignore file.
  Default is ``$CWD/.gitignore``.
--force, -f
  Overwrite ``.gitignore`` file even if it already exists.
  Default is ``false``.
--update, -u
  Update buckets of target sources before generate file.
  Default is ``false``.

Usecases
========

Use single source
-----------------

.. code:: console

   gigi create Nim
