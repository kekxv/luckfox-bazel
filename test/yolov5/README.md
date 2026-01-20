```
[root@luckfox tmp]# ./test-yolov5s bus.jpg
rknn_api/rknnrt version: 2.3.2 (429f97ae6b@2025-04-09T09:11:49), driver version: 0.8.2
model input num: 1, output num: 3
input tensors:
  index=0, name=images, n_dims=4, dims=[1, 640, 640, 3], n_elems=1228800, size=1228800, fmt=NHWC, type=INT8, qnt_type=AFFINE, zp=-128, scale=0.003922
output tensors:
  index=0, name=output, n_dims=4, dims=[1, 80, 80, 255], n_elems=1632000, size=1632000, fmt=NHWC, type=INT8, qnt_type=AFFINE, zp=-128, scale=0.003860
  index=1, name=283, n_dims=4, dims=[1, 40, 40, 255], n_elems=408000, size=408000, fmt=NHWC, type=INT8, qnt_type=AFFINE, zp=-128, scale=0.003922
  index=2, name=285, n_dims=4, dims=[1, 20, 20, 255], n_elems=102000, size=102000, fmt=NHWC, type=INT8, qnt_type=AFFINE, zp=-128, scale=0.003915
custom string:
Begin perf ...
   0: Elapse Time = 100.09ms, FPS = 9.99
model is NHWC input fmt
 post_process Time = 10.06ms, FPS = 99.38
person @ (208 244 286 506) 0.884136
person @ (479 238 560 526) 0.863766
person @ (110 236 230 535) 0.832498
bus @ (94 130 553 464) 0.697389
person @ (79 354 122 516) 0.349307
```