#include "ps4.h"
#include <string.h>

#define NOTIFY_MESSAGE "\xE2\x98\x85RikuHen\xE2\x98\x85"

static void send_notification(const char *msg)
{
    SceNotificationRequest req;

    memset(&req, 0, sizeof(req));

    strncpy(req.message, msg, sizeof(req.message) - 1);
    req.message[sizeof(req.message) - 1] = '\0';

    sceKernelSendNotificationRequest(0, &req, sizeof(req), 0);
}

int _main(struct thread *td)
{
    UNUSED(td);

    initKernel();
    initLibc();
    initSysUtil();

    send_notification(NOTIFY_MESSAGE);

    return 0;
}
