#!/usr/bin/env ash

# Script to print out the information needed to use the container on boot
nohup factom-walletd -s=$FACTOMDHOST &

echo ""
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@ This container has the ability to create an identity and add it the blockchain @"
echo "@    It can be configured to use a different factom target in the DockerFile     @"
echo "@                Currently using: $FACTOMDHOST as target                         "
echo "@ Container Contains:                                                            @"
echo "@         factom-cli                                                             @"
echo "@         factom-walletd (running)                                               @"
echo "@         serveridentity                                                         @"
echo "@         signedwithed25519                                                      @"
echo "@         golang                                                                 @"
echo "@         glide                                                                  @"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""
echo "Ensure this is the current height of the network:"
factom-cli -s $FACTOMDHOST get heights
echo ""
echo "@ How to create an Identity"
echo "@   STEP 1"
echo "@     Use serveridentity to create the identity and it's keys (does not make api calls)"
echo "@         \`serveridentity full elements {ESKEY} -n create -f -s $FACTOMDHOST\`"
echo "@     Copy down:"
echo "@         4 Level Keys"
echo "@         4 Public keys and ID keys (they are the same, but pub is easier to use in hex form)"
echo "@         Root + Management Chain"
echo "@         Block signing key (pub & priv)"
echo "@         BTC Key + MHash seed"
echo ""
echo "@   STEP 2"
echo "@     Once you have all the info written down, let's add the entries to the blockchain."
echo "@     First we need to add our entrycredit address to the factom-walletd"
echo "@         \`factom-cli importaddress {ESKEY}\`"
echo "@     Check the balance with \`factom-cli -s $FACTOMDHOST listaddresses\`"
echo "@     There is a script create.sh we can execute to make the entries into the blockchain."
echo "@         \`/bin/ash create.sh\`"
echo "@     IF IT FAILS -- Check if the wallet is running: \`ps -aef | grep wallet\`"
echo "@      -> Start the wallet like so\`nohup factom-walletd -s=$FACTOMDHOST &\`"
echo ""
echo "@   STEP 3"
echo "@     Wait for a block to be created, check your identity made it in."
echo "@     Do not delete this container until it is in. The block signing private key is on disk"
echo "@     We will need to delete the container and temporary volume when everything is complete and"
echo "@     written down."
echo ""
echo "@   STEP 4 (Cleanup)"
echo "@     \`exit\` to leave"
echo "@     Run \`cleanup.sh\` on the host machine, say 'y'"






