/* EECS 4422 */
/* Assignment 1 */
/* Michael Williams, mw1992, 211087798 */
/*Andrew Lau, pellost, 212905253 */

function testGaborFilters(k, theta)
"this function tests the gabor filters at a given wavenumber(k) and at various angles(theta).  Initital angle is 0.  Each new image taken rotates the filters by the theta value given.  For example, if theta = 30 degrees, the first image will have the filters applied at an angle of 0 degrees, the next at an angle of 30, etc\n"
{
   /* declare variables and assign value to them*/
    local deviation, angle;
   
    angle=0.0;
    deviation=1/k; 

    img = NIL;

/*set up camera */

cam=LT_C920("/dev/video0");

v4l2_streamon(cam);

/*create loop to continuously grab images and perform operations on them*/
for(Tk_Button_Set();!Tk_Button_Pressed(); angle = angle+theta)
{

  gshow(img=v4l2_grab(cam),:tk_img="ltech",:update_now=t); 

/*change image to grey scale*/

 imgg = (img->r+img->g+img->b);
 imgg /= 3;

    /* compute the cos and sin gabors */

   cgabor = mk_cgabor_tmpl2(deviation,:k=k,:theta=angle); 
    sgabor = mk_sgabor_tmpl2(deviation,:k=k,:theta=angle); 

 /*get the convolution of the image on with individual gabors */

         c_image = imgg(*)cgabor;
        s_image = imgg(*)sgabor;

 /* produce the final image by squaring the images and adding them together.  Then display it */

        final_image = (c_image * c_image) + (s_image * s_image);
        gshow(final_image,:rescale=t);

};

v4l2_streamoff(cam);

};
