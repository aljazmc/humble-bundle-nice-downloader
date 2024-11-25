import { version as packageVersion } from "../package.json";
import { version as manifestVersion } from "../src/manifest.json";

test('packageVersion matches manifestVersion', () => {

  expect(packageVersion.match(manifestVersion));

});
