import values from 'lodash/values'

export function buildAutoSuggestItems(companies) {
  return values(companies.items).map(item => {
    return {
      id: item.id,
      name: item.name,
      ticker: item.ticker
    }
  })
}
