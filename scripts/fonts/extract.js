const puppeteer = require('puppeteer');
const path = require('path');
const url = require('url');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  const filePath = path.resolve(__dirname, 'blocks-scale.svg');
  const fileUrl = url.pathToFileURL(filePath).href;

  await page.goto(fileUrl);

  // Get SVG size
  const { width, height } = await page.evaluate(() => {
    const svg = document.querySelector('svg');
    // Get bounding box size (viewBox or width/height attribute)
    const bbox = svg.getBoundingClientRect();
    return { width: Math.ceil(bbox.width), height: Math.ceil(bbox.height) };
  });

  // Set viewport to SVG size
  await page.setViewport({ width, height });

  for (let t = 0; t < 2.5; t += 1 / 30)  {
    await page.evaluate((time) => {
      document.documentElement.setCurrentTime(time);
    }, t);

    // Screenshot with clipping to SVG bounding box
    await page.screenshot({ 
      path: `frame-${t.toFixed(3)}.png`,
      clip: { x: 0, y: 0, width, height }
    });
  }

  await browser.close();
})();
