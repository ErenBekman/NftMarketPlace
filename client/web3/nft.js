import { eth, getInstance } from './provider'

import EnftStorage from "./artifacts/ENFT.json"

export const totalSup = async () => {
    const storage = await getInstance(EnftStorage)
    const totalSup = await storage.totalSupply.call()
  
    return totalSup
  }