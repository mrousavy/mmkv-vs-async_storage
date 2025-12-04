import { NitroModules } from 'react-native-nitro-modules';
import { DataStorage } from './specs/NitroDataStorage.nitro';

export const NitroDataStorage = NitroModules.createHybridObject<DataStorage>('DataStorage')
