
  							 ____    _____   __  __   ___  __  __   ___   ____    _____ 
  							|  _ \  | ____| |  \/  | |_ _| \ \/ /  |_ _| |  _ \  | ____|
  							| |_) | |  _|   | |\/| |  | |   \  /    | |  | | | | |  _|  
  							|  _ <  | |___  | |  | |  | |   /  \    | |  | |_| | | |___ 
  							|_| \_\ |_____| |_|  |_| |___| /_/\_\  |___| |____/  |_____|


  Steps for Deploying smart contracts.
In the main screen, under Environments, select Solidity to configure Remix for Solidity development, then navigate to the File Explorers view.

You will create a new file to save the Solidity smart contract. Hit the + button under File Explorers and enter the name in the pop-up.

After finishing developing, navigate to the Compile sidebar option and press the Compile button

You will see Remix download all of the OpenZeppelin dependencies and compile the contract.

-Now you can deploy the contract by navigating to the Deployment sidebar option. You need to change the topmost Environment dropdown from JavaScript VM to Injected Web3. This tells
Remix to use the MetaMask injected provider, which will point it to your BSC test network. If you wanted to try this using another network, you would have to MetaMask to the correct network instead of your local development node.

As soon as you select Injected Web3, you will be prompted to allow Remix to connect to your MetaMask account.

Press Next in Metamask to allow Remix to access the selected account.

Back on Remix, you should see that the account you wish to use for deployment is now managed by MetaMask.

If you have to deploy several files , it is good choice to use flattner plguin.

For that Press the plugin button and find flattner and enable it.

Press flattner extension and select the contract you want to deploy and press flattner button.

After generating flatter.sol file save it and deploy it.

You have only one flattner single file so it is good for deploying without complexity.


Next to the Deploy button.

Once you have entered value to the construtor, select Deploy.

You will be prompted in MetaMask to confirm the contract deployment transaction.

After you press Confirm and the deployment is complete, you will see the transaction listed in MetaMask. The contract will appear under Deployed Contracts in Remix.




Verification.


In the binance smart chain, find the address of the contract.

Then press contract button and you can see the link  "verify and publish".

Press this link and you can see the form window and dropdown buttons.

You first need to confirm single solidity file if you are going to use flattener file or single solidity file.

And set the version of the solidity compiler.

Then you set the license as MIT(3rd option).

Then click next button.

you can see another window and the only thing you have to do is copy the code from the single file and paste it to the form.

Then press verify button.

After verification, if you press the contract button, you can see read wirte buttons.

You can interact with the smart contract with these buttons.





	





  