#!/usr/bin/env node
import { createReadStream } from 'fs';
import { createInterface } from 'readline';

const data = '../../data/one/data.txt';

// Returns number based on first and last digits in line
function parseDigits(line) {
  const nums = line.match(/-?\d/g) || [];
  const first = nums[0] || 0;
  const last = nums.length > 1 ? nums[nums.length - 1] : first;
  const num = Number(`${first}${last}`);

  return num;
}

// Returns string of digits based on words in given line
function parseStringDigits(line) {
  const map = { 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9 };
  const mapKeys = Object.keys(map);
  // Split line into list of words and numbers
  const lineWords = line.split(/(?<=\d)(?=[a-z])|(?<=[a-z])(?=\d)/);

  const numList = lineWords.flatMap(word => {
    // If word is a number, return early
    if (!isNaN(parseInt(word))) return word.split('');

    const wordList = word.split('').reduce((acc, _, idx) => {
      mapKeys.forEach(key => {
        const substr = word.slice(idx, idx + key.length);
        if (substr === key) acc.push(map[key]);
      });

      return acc;
    }, []);

    return wordList;
  })

  return parseDigits(numList.join(''));
}

// Returns sum of all numbers in given lines
async function parseLines(lines, parseFn = parseDigits) {
  let values = [];

  for await (const line of lines) {
    values.push(parseFn(line));
  }

  return values.reduce((sum, n) => sum + n, 0);
}

// Part 1 solution
async function part1(fileName) {
  const fileStream = createReadStream(fileName, 'utf8');
  const readLines = createInterface({ input: fileStream, crlfDelay: Infinity });
  const nums = await parseLines(readLines);

  console.log(nums);
}

// Part 2 solution
async function part2(fileName) {
  const fileStream = createReadStream(fileName, 'utf8');
  const readLines = createInterface({ input: fileStream, crlfDelay: Infinity });
  const nums = await parseLines(readLines, parseStringDigits);

  console.log(nums);
}

part1(data);
part2(data);
