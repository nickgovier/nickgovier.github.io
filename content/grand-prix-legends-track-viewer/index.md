# Grand Prix Legends track viewer

Some screenshots to check that decompilation of track loading is correct.

2026-08-09 11:18 (d4a9023)

![monaco1](monaco1.png)

![monaco2](monaco2.png)

![spa1](spa1.png)

![nurburg1](nurburg1.png)

![monza1](monza1.png)

![monza2](monza2.png)

![mexico1](mexico1.png)

2026-08-10 10:19 (a218232)

Some textures

![spa1t](spa1t.png)

![monza2t](monza2t.png)

2026-08-18 19:14 (bbfc7da)

Some alpha

![spa1a](spa1a.png)

![monza2a](monza2a.png)

It took an embarrassing amount of time to figure out why track surface curve polygons were duplicated, where polygons were drawn between every successive vertex, every other vertex, and every fourth vertex:

![lodall](lodall.png)

Was it polygon fans going awry?  Something to do with collision mesh and visible mesh not aligning?

No, it was three LODs all being drawn at once...

![lodh](lodh.png)

![lodm](lodm.png)

![lodl](lodl.png)

I can't think that this actually saved that much, and added the constraint that curve segments needed to be multiples of four vertices, and caused the track to visibly shift outward (away from the apex) as the camera approached.  But I basically reversed the entire rendering pipeline before the obvious answer smacked me in the face.
