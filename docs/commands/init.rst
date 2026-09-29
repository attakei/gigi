========
``init``
========

``init`` subcommand creates :term:`workspace` resources that are settings file and :term:`buckets <bucket>`.

Details
=======

:term:`workspace` is two folders in your local machine.

:Config directory: Manage settings file.
  This is named ``"gigi"`` under shared config-dir by Nim's `std/appdirs`_ module.
  It automatically decide by your operating system.
:Data directory: Manage buckets.
  This is named ``"gigi"`` under shared data-dir by Nim's `std/appdirs`_ module.
  It automatically decide by your operating system.

.. _std/appdirs: https://nim-lang.org/docs/appdirs.html

Usage
=====

.. code:: console

   gigi init [OPTIONS]

Options
=======

--clean/-c
  It removes old workspace directories befor create.
  Default is ``false``.

Usecases
========

First initialize
----------------

When you installed gigi into your machine at first,
you just do `init` subcommand without any options.

.. code:: console

   gigi init

Refresh workspace
-----------------

If you want to recreate workspace due to some reasons,
you have to do subcommand with ``--clean`` option.

.. code:: console

   gigi init --clean

