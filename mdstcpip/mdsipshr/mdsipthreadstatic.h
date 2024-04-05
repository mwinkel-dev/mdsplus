#ifndef _MDSIPTHREADSTATIC_H
#define _MDSIPTHREADSTATIC_H
#include "../mdsshr/mdsthreadstatic.h"
#include "../mdsip_connections.h"

#define MDSIPTHREADSTATIC_VAR MdsIpThreadStatic_p
#define MDSIPTHREADSTATIC_TYPE MdsIpThreadStatic_t
#define MDSIPTHREADSTATIC_ARG MDSIPTHREADSTATIC_TYPE *MDSIPTHREADSTATIC_VAR
#define MDSIPTHREADSTATIC(MTS) MDSIPTHREADSTATIC_ARG = MdsIpGetThreadStatic(MTS)
#define MDSIPTHREADSTATIC_INIT MDSIPTHREADSTATIC(NULL)
//XMW:? Is clientaddr now obsolete?  No references to it or MDSIP_CLIENTADDR in 
//XMW:? the servershr source code.
typedef struct
{
  Connection *connections;
  uint32_t clientaddr;
  int isInitialized;
  int isMainThread;
} MDSIPTHREADSTATIC_TYPE;
#define MDSIP_CLIENTADDR MDSIPTHREADSTATIC_VAR->clientaddr
#define MDSIP_CONNECTIONS MDSIPTHREADSTATIC_VAR->connections
#define MDSIP_G_CONNECTIONS ((MDSIPTHREADSTATIC_TYPE *) accessMainThread)->connections
#define MDSIP_IS_MAIN_THREAD MDSIPTHREADSTATIC_VAR->isMainThread

extern DEFINE_GETTHREADSTATIC(MDSIPTHREADSTATIC_TYPE, MdsIpGetThreadStatic);
#endif // ifndef _MDSIPTHREADSTATIC_H
