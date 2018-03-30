function rand_el(mat)
{
  to_int(random()*mat->vmax+0.5);
};

function pmat(M)
{
    for (i=M->vmin; i<=M->vmax; i++)
    {
      for (j=M->hmin; j<M->hmax; j++)
        {
            printf("%f, ", M[i,j]);
        };
  printf("%f\n", M[i,M->hmax]);
    };
};

function pvec(V)
{
  for (i=1;i<=V->vsize;i++)
  {
    printf("%f\n",V[i]);
  };
};

function take_pic()

{
    con = fc2GetContext();
    con->camindex=0;
    fc2StartGrab(con);
    img=NIL;
    img = fc2GrabImgBW(con,img);
    con = NIL;
    GC();

};

function webcam()
{
  cam=LT_C920("/dev/video0");
  v4l2_streamon(cam); 
  for(Tk_Button_Set();!Tk_Button_Pressed(); gshow(img=v4l2_grab(cam),:tk_img="ltech",:update_now=t));
  v4l2_streamoff(cam);
  cam=NIL;GC();
};

function lineFrom2Points(P1,P2)
{

  local x1, y1, x2, y2;

  x1 = P1[1];
  y1 = P1[2];
  x2 = P2[1];
  y2 = P2[2];
  m = (y2-y1)/(x2-x1);
  b = y2 - m*x2;
  m;
};

function sqr(x)
{
    x*x;
};

function dst(P1, P2, P0)
{
    local x1, y1, x2, y2, x0, y0;

    x1 = P1[1];
    y1 = P1[2];
    x2 = P2[1];
    y2 = P2[2];
    x0 = P0[1];
    y0 = P0[2];

    fabs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1)/sqrt(sqr(y2-y1) + sqr(x2-x1));
};

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
  "Starts a display [pointPicker] with the image im at [destX, DestY], [5,5].\n\
The user is expected to select a number of point by pointing and clicking\n\
with the middle mouse button. Unless wait is set to NIL, the function will\n\
not return before the user clicks the user defined button which is now\n\
labeled Picked. If bell is set to t [t], the bell will ring."
{
   gshow(im,
    :display=display, :tk_img=tk_img, :comment=comment,
    :destX=destX, :destY=destY,
    :update_now=update_now, :rescale=rescale);
   Tcl_Eval(sprintf("match_bind %s %s",display,tk_img));
   if (wait)
    Tk_Button_wait("Picked",:bell=bell);

    mat = match_end1(:tk_img="pointpick",:display = "pointPicker",:minpoints=3);
};

function best_points(mat) {
  local P1, P2, count, current, best, best_count, a,b;
  best_count = 0;
  count = 0;


  for (i = 0; i < 200; i++)
  {
    P1 = mat[rand_el(mat),1..2];
    P2 = P1;
    while (P1[1] == P2[1] && P1[2] == P2[2]) {
      P2 = mat[rand_el(mat),1..2];
    };
    count = 0;
    current = P1<|>P2;
    for (j = 1; j <= mat->vmax; j++)
    {
      P0 = mat[j,1..2];
      
      if (dst(P1,P2,P0) <= 10)
      {
        count++;
        current = current<|>P0;
      };
    };
    if (count >= best_count)
    {
       best_count = count;
       best = current;
    };
  };
  P1 = best[1,1..2];
  P2 = best[2,1..2];
  lineFrom2Points(P1,P2);
  pos1 = mk_fvec(2,[0,to_int(b)]);
  pos2 = mk_fvec(2,[img->hmax+1,to_int(b+(img->hmax+1)*m)]);
  draw_line(img,pos1,pos2-pos1,250);
  best;
};

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

function fit_line(mat,img)
{
  local N, ones, mean, cov;
  mat = mat^T;
  N = mat->hsize;
  ones = mk_fvec(N)+1;
  mean = mat*ones/N;
  cov = mat*mat^T/N - mean*mean^T;
  
  lam1 = (cov[1,1]+cov[2,2]+sqrt((cov[1,1]-cov[2,2])^2+4*cov[1,2]^2))/2.0;
  lam2 = (cov[1,1]+cov[2,2]-sqrt((cov[1,1]-cov[2,2])^2+4*cov[1,2]^2))/2.0;
  
  VV=cov-lam2;
    VV = VV*VV;
    d = VV[1..2,1];
    d /= gnorm(d);
    mat =mat^T;
  
  
  
};


function question3()
{
  take_pic();
/*    webcam(); */
/*    img = (img->r+img->g+img->b)/3; */
/*    img = to_ucimg(to_ucmat(img)); */
  
/*  img = mk_fimg(640,640); */
/*  img[100..500,300..340] += 20; */
/*  img = rescale_img(img); */
/*  img = to_ucimg(img); */
  

    pointpick_start(img);

    best = best_points(mat);
    fit_line(best,img);
    slope = m;
    
    mat = leftover(best,mat);
    best2 = best_points(mat);
    slope2 = m;
    
    while (fabs(slope2 - slope)/slope < 0.1)
    {
      mat = leftover(best,mat);
      best2 = best_points(mat);
      slope2 = m;
    };
    
    fit_line(best2,img);
  gshow(img);
    

};




