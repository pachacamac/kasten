#include "kasten.h"

VALUE rb_mKasten;

void
Init_kasten(void) {
  rb_mKasten = rb_define_module("Kasten");
  rb_define_singleton_method(rb_mKasten, "kasten", method_kasten, 0);
}

VALUE method_kasten(VALUE self){
  int rx = 0, ry = 0, rw = 0, rh = 0, rect_x = 0, rect_y = 0, rect_w = 0, rect_h = 0, btn_pressed = 0, done = 0;
  Screen *scr = NULL;
  Window root = 0;
  Cursor cursor, cursor2;
  XGCValues gcval;
  GC gc;
  VALUE r_hash;
  XEvent ev;
  Display *disp = XOpenDisplay(NULL);
  if(!disp){ return EXIT_FAILURE; }
  scr = ScreenOfDisplay(disp, DefaultScreen(disp));
  root = RootWindow(disp, XScreenNumberOfScreen(scr));
  cursor = XCreateFontCursor(disp, XC_left_ptr);
  cursor2 = XCreateFontCursor(disp, XC_lr_angle);
  gcval.foreground = XWhitePixel(disp, 0);
  gcval.function = GXxor;
  gcval.background = XBlackPixel(disp, 0);
  gcval.plane_mask = gcval.background ^ gcval.foreground;
  gcval.subwindow_mode = IncludeInferiors;
  gc = XCreateGC(disp, root, GCFunction | GCForeground | GCBackground | GCSubwindowMode, &gcval);

  /* this XGrab* stuff makes XPending true ? */
  if ((XGrabPointer (disp, root, False, ButtonMotionMask | ButtonPressMask | ButtonReleaseMask, GrabModeAsync, GrabModeAsync, root, cursor, CurrentTime) != GrabSuccess)){
    printf("no mouse pointer!");
  }

  if ((XGrabKeyboard (disp, root, False, GrabModeAsync, GrabModeAsync, CurrentTime) != GrabSuccess)) {
    printf("no keyboard!");
  }

  while (!done) {
    //~ while (!done && XPending(disp)) {
      //~ XNextEvent(disp, &ev);
    if (!XPending(disp)) { usleep(1000); continue; } // fixes the 100% CPU hog issue in original code
    if ( (XNextEvent(disp, &ev) >= 0) ) {
      switch (ev.type) {
        case MotionNotify:
        /* this case is purely for drawing rect on screen */
          if (btn_pressed) {
            if (rect_w) {
              /* re-draw the last rect to clear it */
              XDrawRectangle(disp, root, gc, rect_x, rect_y, rect_w, rect_h);
            } else {
              /* Change the cursor to show we're selecting a region */
              XChangeActivePointerGrab(disp, ButtonMotionMask | ButtonReleaseMask, cursor2, CurrentTime);
            }
            rect_x = rx;
            rect_y = ry;
            rect_w = ev.xmotion.x - rect_x;
            rect_h = ev.xmotion.y - rect_y;
            if (rect_w < 0) { rect_x += rect_w; rect_w = 0 - rect_w; }
            if (rect_h < 0) { rect_y += rect_h; rect_h = 0 - rect_h; }
            /* draw rectangle */
            XDrawRectangle(disp, root, gc, rect_x, rect_y, rect_w, rect_h);
            XFlush(disp);
          }
          break;
        case ButtonPress:
          btn_pressed = 1;
          rx = ev.xbutton.x;
          ry = ev.xbutton.y;
          break;
        case ButtonRelease:
          done = 1;
          break;
      }
    }
  }
  /* clear the drawn rectangle */
  if (rect_w) {
    XDrawRectangle(disp, root, gc, rect_x, rect_y, rect_w, rect_h);
    XFlush(disp);
  }
  rw = ev.xbutton.x - rx;
  rh = ev.xbutton.y - ry;
  /* cursor moves backwards */
  if (rw < 0) { rx += rw; rw = 0 - rw; }
  if (rh < 0) { ry += rh; rh = 0 - rh; }

  XCloseDisplay(disp);
  //printf("%dx%d+%d+%d\n",rw,rh,rx,ry);

  r_hash = rb_hash_new();
  rb_hash_aset(r_hash, rb_str_new2("x"), INT2NUM(rx));
  rb_hash_aset(r_hash, rb_str_new2("y"), INT2NUM(ry));
  rb_hash_aset(r_hash, rb_str_new2("w"), INT2NUM(rw));
  rb_hash_aset(r_hash, rb_str_new2("h"), INT2NUM(rh));
  return r_hash;
}
