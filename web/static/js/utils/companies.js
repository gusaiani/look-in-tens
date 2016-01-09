import values from 'lodash/object/values'

export function buildAutoSuggestItems(items) {
  return values(items).map(item => {
    return {
      id: item.id,
      text: `${item.ticker} · ${item.name}`
    }
  })
}
