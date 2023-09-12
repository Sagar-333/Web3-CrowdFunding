import React, {useContext,createContext} from "react";
import {useAddress, useContract, useMetamask, useContractWrite } from '@thirdweb-dev/react'
import { ethers } from "ethers";

const StateContext = createContext();

export const StateContextProvider = ({children}) => {
    const {contract} = useContract('0x3CcEC1556b99c06D0B97A713e39B0f7d8336E49F');
    const { mutateAsync: createCampaign } = useContractWrite(contract, 'createCampaign');

    const address = useAddress();
    const connect = useMetamask();

    const publishCampaign = async(form) => {
        try {
            const data = await createCampaign([
                address,
                form.title,
                form.description,
                form.target,
                new Date(form.deadline).getTime(),
                form.image
            ])
            console.log('contract call success', data)

        } catch (error) {
            console.log('contract call failed',error)
        }
    }

    return(
        <StateContext.Provider
            value={{
                address,
                contract,
                createCampaign: publishCampaign,

            }}
        >
            {children}
        </StateContext.Provider>
    )
}
export const useStateContext = () => useContext(StateContext);