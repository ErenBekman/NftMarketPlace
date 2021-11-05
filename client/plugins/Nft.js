import Nft from '../../build/contracts/ENFT.json'

export default async ({ app }, inject) => {    
    inject('Nft', Nft)
}