package karate.example.runner;

import com.intuit.karate.Results;
import com.intuit.karate.junit5.Karate;
import io.qameta.allure.karate.AllureKarate;

class ExamplesRunner {

    @Karate.Test
    Karate testExample() {
        return Karate.run("classpath:karate/example")
                .tags("@DeepakFeature")
                .relativeTo(getClass())
                .hook(new AllureKarate());
    }

    @Karate.Test
    Results testExampleParallel() {
        return Karate.run("classpath:karate/example")
                .tags("@Example")
                .relativeTo(getClass())
                .hook(new AllureKarate()).parallel(2);
    }
}
