/*
Copyright (c) 2017, Massachusetts Institute of Technology All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include <libroutines.h>
#include <stdlib.h>

#include "../mdsip_connections.h"

extern int _TreeClose();
extern int TdiSaveContext();
extern int TdiDeleteContext();
extern int TdiRestoreContext();
extern int MDSEventCan();

int CloseConnectionC(Connection *connection)
{
  int status = 0;
  if (connection)
  {
    void *tdi_context[6];
    MdsEventList *e, *nexte;
    FreeDescriptors(connection);
    for (e = connection->event; e; e = nexte)
    {
      nexte = e->next;
      /**/ MDSEventCan(e->eventid);
      /**/ if (e->info_len > 0)
        free(e->info);
      free(e);
    }
    do
    {
      status = _TreeClose(&connection->DBID, 0, 0);
    } while (STATUS_OK);
    TdiSaveContext(tdi_context);
    TdiDeleteContext(connection->tdicontext);
    TdiRestoreContext(tdi_context);
    status = DisconnectConnection(connection->id);
  }
  return status;
}

int CloseConnection(int id)
{
  Connection *connection = FindConnection(id, NULL);
  return CloseConnectionC(connection);
}