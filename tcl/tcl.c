#include        "tcldef.h"

/***********************************************************************
* TCL.C --
*
* The TCL main program
*
* History:
*  07-Jan-1998  TRG  Create.
*
************************************************************************/


#ifdef vms
static char  set_command[] = "\
set command tcl_commands\
  /prompt=\"TCL> \"\
  /def_file=\"*.tcl\"\
";
#else
static char  set_command[] = "\
set command tcl_commands\
  -prompt=\"TCL> \"\
  -def_file=\"*.tcl\"\
";
#endif


	/****************************************************************
	 * main:
	 * TCL main program ...
	 ****************************************************************/
main(				/* TCL main program			*/
    int   argc			/* <r> arg count			*/
   ,char  *argv[]		/* <r> arguments array			*/
   )
   {
    int   i,k;
    int   sts;

    set_pgmname(argv[0]);
    sts = mdsdcl_do_command(set_command);

    if (~sts & 1)
        exit(mdsMsg(sts,"Error in startup"));

    for ( ; ; )
       {
        sts = mdsdcl_do_command(0);
        if (sts == CLI_STS_EOF)
            exit(0);
       }
   }
