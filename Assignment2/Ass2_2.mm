/*pick points off an image */

function pointpick_start(im,
             &optional
             display &init "pointPicker",
             tk_img &init "pointpick",
             comment &init "{}",
             destX &init 5,
             destY &init 5,
             update_now,
             rescale,
             wait &init t,
             bell &init t)
{
   gshow(im,
    :display=display, :tk_img=tk_img, :comment=comment,
    :destX=destX, :destY=destY,
    :update_now=update_now, :rescale=rescale);
   Tcl_Eval(sprintf("match_bind %s %s",display,tk_img));
   if (wait)
    Tk_Button_wait("Picked",:bell=bell);

     dataset = match_end1(:tk_img="pointpick",:display = "pointPicker",:minpoints=3);
	
};

function sqr(i)
{
	i * i;
};

function rand_el(mat)
{
  to_int(random()*mat->vmax+0.5);
};

function ransac()
{ 

/*set up camera*/

  cam=LT_C920("/dev/video0");
  v4l2_streamon(cam); 
  for(Tk_Button_Set();!Tk_Button_Pressed(); gshow(img=v4l2_grab(cam),:tk_img="ltech",:update_now=t));
  v4l2_streamoff(cam);
  cam=NIL;GC();

/*convert image to greyscale */
img = v4l2_grab(cam);
imgg = (img->r+img->g+img->b) / 3;

pointpick_start(imgg);


best_count = 0;


/*keep going while at least 3 points ar in the dataset */
while ( dataset->vmax >= 3){
	for(i=0; i<200; i++){
		
		/* get three random points from dataset */
		pt1 = dataset[rand_el(dataset),1..2];
		pt2 = pt1;
		pt3 = pt2;
	
		while (pt1 == pt2 || pt2 == pt3 || pt3 == pt1){
			pt2 = dataset[rand_el(dataset),1..2];
			pt3 = dataset[rand_el(dataset),1..2];
		};

		/*find the circle of best fit from these 3 points */
		
		D11 = pt1[1];
		D12 = pt1[2];
		D13 = 1;

		D21 = pt2[1];
		D22 = pt2[2];
		D23 = 1;
		
		D31 = pt3[1];
		D32 = pt3[2];
		D33 = 1;

		/*create matrix D */
		D = mk_fmat(3,3,[[D11, D12, D13], [D21, D22, D23], [D31, D32, D33]]);	

		/*create matrix C */
		C1 = -((D11 * D11) + (D12 *D12));
		C2 = -((D21 * D21) + (D22 *D22));
		C3 = -((D31 * D31) + (D32 *D32));


		C = mk_fvec(3, [C1, C2, C3]);

		/*create matrix A, ie the inverse of matrix D X matrix C */
		A = inverse_mat(D) * C;

		/*calculate and assign circle info */
		near_points = mk_vec(2)
		centreX = A[1]/2;
		centreY = A[2]/2;	
		radius	= sqrt(-(A[3]) + (centreX * centreX) + (centreY * centreY));

		/*should now have the circle coordinates */
		/*next, check which points fit in the circle model */

		/*may not work, its supposed to remove the points from the dataset*/



		dataset = leftover(pt1, dataset);
		dataset = leftover(pt2, dataset);
		dataset = leftover(pt3, dataset);
		
		for(i=1; i<=dataset->vmax;i++){

			pt = dataset[i,1..2];
			
			distance = sqrt(sqr(pt[1]-centreX) + sqr(pt[2]-centreY));
			
			if (distance <= sqr(radius)){
				distance = abs(radius - distance);
			}else{
			
				distance = abs(distance - radius);
			};
			
			if (distance <= 5){
				if(near_points->vmax == 1){
					near_points = pt;
				}else{
					near_points = near_points <-> pt;
				};
		};
				
			/*we use a threshold on a circle so that its only valid if we find at least 6 points along it */
			
				if (near_points->vmax >= 6)
				{
				near_points	= near_points <-> pt1 <-> pt2 <-> p3;

				/*find points matching along the near_points*/

				for(i=1; i<=near_points->vmax;i++){

					pt = near_points[i,1..2];
			
					distance = sqrt(sqr(pt[1]-centreX) + sqr(pt[2]-centreY));
			
					if (distance <= sqr(radius)){
						distance = abs(radius - distance);
					}else{
			
						distance = abs(distance - radius);
					};
					
					final_points = mk_vec(2);

					if (distance <= 5){
						if(near_points->vmax == 1){
							final_points = pt;
						}else{
							final_points = final_points <-> pt;
						};
				};

			/*now we take the best results*/
			if (final_points->vmax > best_count)
			{

				best = [centreX, centreY, radius];
				best_count = final_points->vmax;
				
			};


		};

				if (final+
				
				
				};

		};

	};
};



/*ransac algorithm*/
};









/*function to remove points from the dataset matrix */

function leftover(best,mat)
{
  local out,match;
  match = !t;
  out = mk_fmat(1,2);
  
  for (i=1; i<=mat->vmax; i++)
    {
     p1 = mat[i,1..2];
     match = !t;
      for (j=1; j<=best->vmax; j++)
        {
          p2 = best[j,1..2];
          if (p1[1] == p2[1] && p1[2] == p2[2])
            {
              match = t;
            };
        };
      if (!match) 
      {
        out = out<|>p1;
      };
    };
   out[2..out->vmax,1..2];
};
