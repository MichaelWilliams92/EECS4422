
	/*make image and include white parts in it (we include 3 for now) */
	img = mk_fimg(512,512);

	for(i = 1; i < 512; i++){
		for(j=1; j<50;j++){
			img[i,j] = 255;
		};
	};

	for(i = 460; i < 512; i++){
		for(j=60; j<512;j++){
			img[i,j] = 255;
		};
	};

	for(i = 300; i < 400; i++){
		for(j=300; j<400;j++){
			img[i,j] = 255;
		};
	};

	/*for(i = 1; i < 30; i++){     */
	/*	for(j=475; j<511;j++){ */
	/*		img[i,j] = 255;*/
	/*	};                     */
	/*};                             */

	for(i = 1; i < 20; i++){
		for(j=470; j<511;j++){
			img[i,j] = 255;
		};
	};

	gshow(img);
	/*now we have an image with 3 white blocks*/

	/*create matrix of starting point.  [1,1] will contain y and [2,1] will contain x*/		
	start = mk_fmat(2,1,[[10], [500]]);
	/*rememeber, we have to traverse from the second point when looking at the results*/
	result = mk_fmat(2,1,[[1], [1]]);
	
	
	/*D algorithm should now take a starting point given along with the image and perform DFS*/

	/*besides start point and the image, we need the max values, be sure to get these later*/
	/*get max x and y values from web cam values. Min x and y values are 1 */
	
	hmax = 512;
	vmax = 512;
	count = 1;
	imgg = mk_fimg(512,512);
	

/*function will perform DFS on an image given its starting point and find all white pixels*/
function DFS(img, start)
{

	/*result will start by holding the starting point. Its assumed starting point is white*/
	/*label start as 0 and add its location to the result matrix.  */
	
	y = to_integer(start[1,1]);
	x = to_integer(start[2,1]);

	img[y,x] = 0;
	count ++;
	point = mk_fvec(2, [y,x]);
	result = result <-> point;
	
	/*gshow(imgg);*/

	/*now we look at the sourrounding pixels and recursively call the function for any white ones*/

	/*pixel to the left*/
	if (x-1 < 1 || x-1 >=hmax){
		/*do nothing if out of boundary*/
	} else {

		if (img[y, x-1] > 0)
		{
	 	   start = mk_fmat(2,1,[[y], [x - 1]]);
	 	   DFS(img, start);
		};
	
	/*else block */
	};


	/*pixel above*/
	if (y-1 < 1 || y-1 >=vmax){
		/*do nothing if out of boundary*/
	} else {

		if (img[y-1, x] > 0)
		{
	 	   start = mk_fmat(2,1,[[y-1], [x]]);
	 	   DFS(img, start);
		};
	
	/*else block */
	};

	/*pixel to the right*/
	if (x+1 < 1 || x+1 >=hmax){
		/*do nothing if out of boundary*/
	} else {

		if (img[y, x+1] > 0)
		{
	 	   start = mk_fmat(2,1,[[y], [x + 1]]);
	 	   DFS(img, start);
		};
	
	/*else block */
	};

	/*pixel below*/
	if (y+1 < 1 || y+1 >=vmax){
		/*do nothing if out of boundary*/
	} else {

		if (img[y+1, x] > 0)
		{
	 	   start = mk_fmat(2,1,[[y+1], [x]]);
	 	   DFS(img, start);
		};
	
	/*else block */
	};

	




};

function printer(){

	for(i = 2; i <= count; i++){

		imgg[to_integer(result[1, i]), to_integer(result[2,i])] = 255;

	};	

};

 function test(x){

if (x == 1){ printf("hello");};
if (x == 1){ printf("goodbye");};

};
