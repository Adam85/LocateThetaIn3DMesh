LocateThetaIn3DMesh: Locate Tetrahedra in 3D Mesh
=============================

![Version](https://img.shields.io/badge/version-1.0-green.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

Overview
--------

This project provides MATLAB scripts for localization of 3D point in tetrahedral mesh.

Author
------

Author: Adam Dziekonski, Dr.Eng.
Date of publication: August 2018

Software requirements
----------------------------------
Matlab

Details
-------

File `run_JumpAndWalk_3D.m`:
 - loads a mesh generated in Netgen,
 - runs a jump-and-walk algorithm implementation written based on [1][2][3],
 - compares jump-and-walk with a reference (naive) implementation  localization of 3D point.

Setup execution flags are gatered and described (commented) in first lines of the script: `run_JumpAndWalk_3D.m` 

A jump phase is implemented in file: `jumpToStartingTetrahedron.m`
There are two variants of a walk phase:
 - visibility walk: `visibility_walk_3D.m`
 - stochastic walk: `stochastic_walk_3D.m`


The proposed LocateThetaIn3DMesh scripts enable to find a single point/tetrahedron as well as multiple points/tetrahedra (see loop `for n = 1:NoOfPoints (...) end` in `run_JumpAndWalk_3D.m`). The example of the second case is to find  points that are nodes of  mesh (see proposed Examples #1,#2,#3). Scripts also enable to find multiple destination points in mesh which can lie not only inside a tetrahedron but also lie on a face of tetrahedron.


LocateThetaIn3DMesh enables also a looped jump-and-walk algorithm: in case a walk did not found a destination point then jump phase is performed with new setup and walk is repeated (see loop `for nt = 1:nTests  (...) end` in `run_JumpAndWalk_3D.m`).


Example
-------
Below the shortened output of localization of 324 points (which are nodes of a mesh) in 409k tetrahedral mesh (`shaft.geo` structure from Netgen) is presented:

```
>> run  run_JumpAndWalk_3D.m

No. of tetrahedra = 409600
No. of DestinationPoints = 324 

| Success: 324 | Failed: 0 | All: 324 |

*** Teta(in)Jump = 0.100 % ****
Time naive = 489.900 s
Time jump-and-walk   = 3.288 s

JUMP&WALK stats:
Time of jump  = 0.167 s [5.1%]
Time of walk  = 3.121 s [94.9%]

Speedup jump-and-walk vs. Reference  = 149.0

*** *** ****
REFERENCE loop and Jump-and-Walk have found THE SAME  tetrahedra
*** *** ****
```
One can notice that the implemented jump-and-walk algorithm achieves 149 acceleration over a reference localization. 

References
-----------
[1] Devillers, Olivier, Sylvain Pion, and Monique Teillaud. "Walking in a triangulation." International Journal of Foundations of Computer Science 13.02 (2002): 181-199.
[2] Soukal, Roman. "Walking location algorithms: technical report no. DCSE/TR-2010-03." (2010).
[3] Mücke, Ernst P., Isaac Saias, and Binhai Zhu. "Fast randomized point location without preprocessing in two-and three-dimensional Delaunay triangulations." Computational Geometry 12.1-2(1999): 63-83.

License
-------

LocateThetaIn3DMesh is an open-source Matlab code licensed under the [MIT license](http://opensource.org/licenses/MIT).