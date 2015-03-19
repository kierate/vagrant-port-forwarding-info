#
# Grab the ports from the VM info details.
#

echo ""
echo ""

# start with the HTTP port
HTTP_PORT=`VBoxManage showvminfo $1 --details | grep "guest port = 80" | sed 's/.*host port = \([0-9]*\).*/\1/'`

# prepend ":" if the port is other then 80
if [ -z "$HTTP_PORT" ] || [ $HTTP_PORT -eq "80" ]; then
    HTTP_PORT=""
else
    HTTP_PORT=":$HTTP_PORT"
fi

# get all deployments used on this vagrant box (grabs the $DEPLOYMENTS array)
source `dirname "$BASH_SOURCE"`/deployments.sh

# list all deployment URLs with the correct ports
echo "Available deployments can be accessed on the following URLs:"
for DEPLOYMENT in $DEPLOYMENTS
do
    echo "    http://$DEPLOYMENT$HTTP_PORT"
done

echo ""

# then show the SSH port
SSH_PORT=`VBoxManage showvminfo $1 --details | grep "guest port = 22" | sed 's/.*host port = \([0-9]*\).*/\1/'`

if [ -z "$SSH_PORT" ] || [ $SSH_PORT -eq "22" ]; then
    SSH_PORT=""
else
    SSH_PORT=" -p $SSH_PORT"
fi

echo "You can ssh into the machine in one of the following ways:"
echo "    vagrant ssh                     (within the vagrant directory)"
echo "    ssh vagrant@localhost$SSH_PORT   (from anywhere)"
echo "    ssh root@localhost$SSH_PORT      (from anywhere)"

echo ""
echo ""