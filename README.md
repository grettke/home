<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Intent</a></li>
<li><a href="#sec-2">2. Contents</a>
<ul>
<li><a href="#sec-2-1">2.1. Source</a></li>
<li><a href="#sec-2-2">2.2. Tangled</a></li>
<li><a href="#sec-2-3">2.3. Weaved</a></li>
</ul>
</li>
</ul>
</div>
</div>

# Intent<a id="sec-1" name="sec-1"></a>

This repository is used to publish my home directory org document. Virtually
all of my development occurs in a private repository. That is responsible for
ongoing, unstable changes. This repository is used to publish a known good and
*working* version of the system.

It contains everything required to build it but for Emacs. It also contains
tangled and weaved artifacts that this system creates.

# Contents<a id="sec-2" name="sec-2"></a>

## Source<a id="sec-2-1" name="sec-2-1"></a>

-   **TC3F.org:** the single literate document
-   **Makefile:** orchestrates the work
-   **Cask:** defines build requirements
-   **publish.txt:** notes on how to prepare the system publishing

## Tangled<a id="sec-2-2" name="sec-2-2"></a>

-   **.org-mode.emacs.el:** "light weight" configuration just for org-mode
-   **.emacs.el:** "fully loaded" configuration

## Weaved<a id="sec-2-3" name="sec-2-3"></a>

-   TC3F.
    -   **txt:** ASCII
    -   **html:** HTML
    -   **pdf:** PDF
