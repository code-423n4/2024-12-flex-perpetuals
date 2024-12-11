
export function pipeFixturesFactory(pipes: Function[]) {
  return async function createFixtures() {
    let data = {}
    for (const pipe of pipes) {
      let newData;
      try {
        newData = await pipe(data);
      } catch (e) {
        console.error(e)
      }
      data = {
        ...data,
        ...newData
      }
    }
    return data
  }
}
