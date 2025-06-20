import com.intuit.karate.junit5.Karate;

class MarvelCharactersRunner {
    @Karate.Test
    Karate testMarvelCharacters() {
        return Karate.run("features/marvel-characters").relativeTo(getClass());
    }
}
