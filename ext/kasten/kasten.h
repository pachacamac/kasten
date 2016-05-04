#ifndef KASTEN_H
#define KASTEN_H 1

#include "ruby.h"
#include<stdio.h>
#include<stdlib.h>
#include<X11/Xlib.h>
#include<X11/cursorfont.h>
#include<unistd.h>

void Init_kasten(void);
VALUE method_kasten(VALUE self);

extern VALUE rb_mKasten;

#endif /* KASTEN_H */
