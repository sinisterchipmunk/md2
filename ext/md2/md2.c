#include "ruby.h"

static VALUE read_gl_commands_ext(VALUE self, VALUE gl_command_count, VALUE gl_command_offset, VALUE gl_command_data);
static VALUE construct_command(VALUE args);
static VALUE cMD2 = Qnil;

void Init_md2()
{
  cMD2 = rb_define_class("MD2", rb_cObject);
  rb_define_method(cMD2, "read_gl_commands_ext", read_gl_commands_ext, 3);
}

/*
Accepts a command count, command offset and filename. The file is opened and the data is read;
an argument error is raised if the file could not be opened or if the exact command count could
not be read from the file. Otherwise, the data is deserialized according to the MD2::Command
documentation and then it is returned as an array of MD2::Command instances.

See the documentation for MD2::Command for the exact algoritm; I couldn't figure out how to
implement it using pure Ruby.
*/
static VALUE read_gl_commands_ext(VALUE self, VALUE gl_command_count, VALUE gl_command_offset, VALUE file_path)
{
  char *cpath = StringValueCStr(file_path);
  FILE *inf = fopen(cpath, "r");
  if (!inf) rb_raise(rb_eArgError, "Could not open file %s to read GL command data!", cpath);
  
  unsigned int command_count = FIX2INT(gl_command_count);
  int command_offset = FIX2INT(gl_command_offset);
  int *cdata = (int *)malloc(sizeof(int) * command_count);
  
  fseek(inf, command_offset, SEEK_SET);
  if (fread(cdata, sizeof(int), command_count, inf) != command_count)
  {
    fclose(inf);
    free(cdata);
    rb_raise(rb_eArgError, "Could not read %d GL commands from file", command_count);
  }
  fclose(inf);
  
  VALUE ary = rb_ary_new();
  int i = 0, error;
  int val;
  while ((val = cdata[i++]) != 0)
  {
    int count;
    if (val > 0) count = val;
    else count = -val;
    
    VALUE sym;
    const char *symcstr;
    if (val > 0) sym = ID2SYM(rb_intern("triangle_strip"));
    else sym = ID2SYM(rb_intern("triangle_fan"));

    // construct the packet which will contain the args to be sent to MD2::Command
    VALUE packet = rb_ary_new();
    // add the render type to the packet
    rb_ary_push(packet, sym);
    
    while (count--)
    {
      float s = *(float *)&cdata[i++];
      float t = *(float *)&cdata[i++];
      int index = cdata[i++];
    
      // add s, t, index to the packet
      rb_ary_push(packet, rb_float_new(s));
      rb_ary_push(packet, rb_float_new(t));
      rb_ary_push(packet, INT2FIX(index));
    }
    
    // construct the MD2::Command from the packet data. If error,
    // intercept it and then break so that we can free cdata properly.
    VALUE command = rb_protect(construct_command, packet, &error);
    if (error) break;
    
    // store the command in the resultant array
    rb_ary_push(ary, command);
  }
  
  free(cdata);
  
  // now that cdata is taken care of, re-raise the error if there was one
  if (error)
    rb_exc_raise(rb_gv_get("$!"));
  
  return ary;
}

static VALUE construct_command(VALUE args)
{
  VALUE cMD2Command = rb_const_get(cMD2, rb_intern("Command"));
  VALUE command = rb_funcall2(cMD2Command, rb_intern("new"), 1, &args);
  return command;
}
