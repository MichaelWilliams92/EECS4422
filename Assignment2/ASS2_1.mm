function Threshold(type)
{
 /*Threshold function will take 1 of 2 types */
/*if type == 1, we perform Adaptive threshold to the image */
/*if type == 0, we perform average threshold to the image */

/*set up camera*/

  cam = LT_C920("/dev/video0");
  v4l2_streamon(cam);

	/*perform live stream */

	for(Tk_Button_Set(:text = "button"); !Tk_Button_Pressed(); )
	{
		/*grab image and convert to greyscale */
		img=v4l2_grab(cam);
    		imgg = (img->r+img->g+img->b) / 3;

		/* set values, maybe problem is right there */
		xmax = get_v4l2height(cam);
		ymax = get_v4l2width(cam);
		average = gsum(imgg);

		/* declare and assign 3X3 matrix coordinates */
		D11 = xmax * ymax;
		D12 = (ymax * (ymax + 1)/2) * xmax;
		D13 = (xmax * (xmax + 1)/2) * ymax;

		D21 = (ymax * (ymax + 1)/2) * xmax;
		D22 = (ymax * (ymax + 1) * (2*ymax + 1)/6) * xmax;
		D23 = (ymax * (ymax + 1)/2) * (xmax * (xmax + 1)/2);

		D31 = (xmax * (xmax + 1)/2) * ymax;
		D32 = (ymax * (ymax + 1)/2) * (xmax * (xmax + 1)/2);
		D33 = (xmax * (xmax + 1) * (2*xmax + 1)/6) * ymax;

		/*create matrix D */		
		D = mk_fmat(3,3,[[D11, D12, D13], [D21, D22, D23], [D13, D32, D33]]);

		/*create matrix C, may need to change*/

		c2 = 0;
		c3 = 0;
		max2 = imgg->hmax;
		max3 = imgg->vmax;
		
		for(j = 1; j <= max2; j++)
		{
			for(i = 1; i <= max3; i++)
			{
				 c2 += (i) * imgg[i, j];
		 		 c3 += (j) * imgg[i, j];
			};
		/* nested for loop */
		};

		C = mk_fvec(3, [average, c2, c3]);

		/*create matrix A, ie the inverse of matrix D X matrix C */
	
		A = inverse_mat(D) * C;
		T00 = A[1];
		T10 = A[2];
		T01 = A[3];

		result = mk_fimg(xmax, ymax);

		/*compute appropriate threshold */
		if(type == 1)
		{				
			result = A[1] + (A[2] * y_img(xmax, ymax)) + (A[3] * x_img(xmax, ymax));
		}
		else
		{
			result += (average / (xmax * ymax));
		};		
		imgg = imgg > result;
		gshow(imgg, :tk_img="gabor", :update_now=t, :rescale = t);
		
	};
	/*end live stream*/
	v4l2_streamoff(cam);
};


