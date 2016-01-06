import { Schema } from 'normalizr'

let company = new Schema('companies', {
  idAttribute: 'id'
})

export const companySchema = company
