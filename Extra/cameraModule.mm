
threshold = 30.0;

currentpoint = mk_fvec(2);

function take_pic()

{
    con = fc2GetContext();
    con->camindex=0;
    fc2StartGrab(con);
    img=NIL;
    gshow(img=fc2GrabImgBW(con,img));
    con = NIL;
    GC();

};


function take_field_pic(){
	take_pic();
	img1 = img;
	img1 = to_fimg(img1) (*) mk_gauss_tmpl(gaus);
	result_img = img;
	printf("Picture Taken");
};

function take_object_pic(){
	take_pic();
	img2 = img;
	img2 = to_fimg(img1) (*) mk_gauss_tmpl(gaus);
	printf("Picture Taken");
};


function get_mask(temp_img){
	
	mask = mk_fimg(temp_img->vmax, temp_img->hmax);
		
	for (i=mask->vmin+1; i<=mask->vmax+1; i++)
    {
      	for (j=mask->hmin+1; j<=mask->hmax+1; j++)
       	{
       
			if (temp_img[i-1,j-1] > threshold)
			{
				pix_point = mk_fvec(1..2, [i-1, j-1]);
				pix_avg = pix_avg <-> pix_point;
				mask[i-1,j-1] = 255;
			};
       		};
	};
	

};

function get_centerpt(obj){
	x_sum = 0;
	y_sum = 0;
	
	for (i = obj->hmin + 1; i <= obj->hmax; i++){
		x_sum += obj[1, i];
		y_sum += obj[2, i];
		
	};
	x_avg = x_sum/(obj->hmax -1);
	y_avg = y_sum/(obj->hmax -1);
	pt = mk_fvec(1..2, [x_avg, y_avg]);

	objectpts = objectpts <-> pt;

	/*This is just to show where the mid point is*/
	for (i = x_avg - 10; i <= x_avg + 10; i++){
		for (j = y_avg - 10; j <= y_avg + 10; j++){

			if(i == x_avg-10 || i == x_avg || i == x_avg+10){
	
				result_img[i,j] = 0;
				mask[i,j] = 0;
			};

			if(j == y_avg-10 || j == y_avg || j == y_avg+10){
				result_img[i,j] = 0;
				mask[i,j] = 0;
			};
		}; 
	};

};



function my_abs(M)
{
    for (i=M->vmin; i<=M->vmax; i++)
    {
      for (j=M->hmin; j<M->hmax; j++)
        {
            if(M[i,j] < 0)
			{
				M[i,j] = -M[i,j];
			};
        };
    };
	M;
};



/*call the picture methods first before this one*/

function findobj(){
	
	/*take_field_pic();*/
	
	/*take_object_pic();*/

	/*get_mask(img2);*/
	


	/*make image and include white parts in it (we include 3 for now) */
	img = mk_fimg(512,512);


	for(i = 1; i < 58; i++){
		for(j=1; j< 58;j++){
			img[i,j] = 255;
		};
	};
	
	for(i = 100; i < 158; i++){
		for(j=100; j< 158;j++){
			img[i,j] = 255;
		};
	};


	for(i = 200; i < 258; i++){
		for(j=200; j< 258;j++){
			img[i,j] = 255;
		};
	};



	for(i = 400; i < 458; i++){
		for(j=400; j< 458;j++){
			img[i,j] = 255;
		};
	};

	gshow(img);


	for(i=0; i<img->vmax; i++){
		for(j=0; j<img->hmax; j++){

			if (img[i,j] > 0){

				printf("hello1");

				printf("working %d %d\n",i,j);

				printf("hello2");
				currentpoint = [i,j];

				printf("entering DPS... \n");
				objectpt = DPS(img,currentpoint);
				

				for(i= 2; i>objectpt->hmax; i++){
					printf("creating image...");
					objimg[objectpt[1,i],objectpt[2,i]] = 255;

				};
				
				gshow(objimg);
				
				/*assume that  I get a 2xN matrix called temp_list */

				/*get_centerpt(temp_list);*/



			};

		};

	};


};

