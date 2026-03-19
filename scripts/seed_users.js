#!/usr/bin/env node
/**
 * Seed script: Clears the Firestore `users` collection and recreates
 * all user documents using the new registration model (via REST API).
 */

const fs = require("fs");
const https = require("https");

const PROJECT_ID = "tap2eat-7642c";
const BASE_URL = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents`;

// Read the Firebase CLI refresh token
const fbConfig = JSON.parse(
  fs.readFileSync(
    "/Users/rasal/.config/configstore/firebase-tools.json",
    "utf8"
  )
);
const REFRESH_TOKEN = fbConfig.tokens.refresh_token;
// Firebase CLI OAuth client credentials (public, embedded in firebase-tools)
const CLIENT_ID =
  "563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com";
const CLIENT_SECRET = "j9iVZfS8kkCEFUPaAeJV0sAi";

function httpsRequest(url, options, body) {
  return new Promise((resolve, reject) => {
    const req = https.request(url, options, (res) => {
      const chunks = [];
      res.on("data", (c) => chunks.push(c));
      res.on("end", () => {
        const text = Buffer.concat(chunks).toString();
        try {
          resolve({ status: res.statusCode, data: JSON.parse(text) });
        } catch {
          resolve({ status: res.statusCode, data: text });
        }
      });
    });
    req.on("error", reject);
    if (body) req.write(body);
    req.end();
  });
}

async function getAccessToken() {
  const params = new URLSearchParams({
    grant_type: "refresh_token",
    refresh_token: REFRESH_TOKEN,
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
  });
  const res = await httpsRequest(
    "https://oauth2.googleapis.com/token",
    {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
    },
    params.toString()
  );
  if (res.status !== 200) {
    throw new Error("Failed to get access token: " + JSON.stringify(res.data));
  }
  return res.data.access_token;
}

function firestoreValue(val) {
  if (val === null || val === undefined) return { nullValue: null };
  if (typeof val === "string") return { stringValue: val };
  if (typeof val === "number")
    return Number.isInteger(val)
      ? { integerValue: String(val) }
      : { doubleValue: val };
  if (typeof val === "boolean") return { booleanValue: val };
  if (Array.isArray(val))
    return { arrayValue: { values: val.map(firestoreValue) } };
  if (typeof val === "object") {
    const fields = {};
    for (const [k, v] of Object.entries(val)) fields[k] = firestoreValue(v);
    return { mapValue: { fields } };
  }
  return { stringValue: String(val) };
}

// Users data with the new model
const USERS = [
  {
    uid: "xBvjKVtdXFW7FkaqVN26ZlBqeq73",
    name: "Rahul Verma",
    email: "student1@tap2eat.com",
    role: "student",
    designation: "cs",
    block_name: "A",
    classroom_number: "101",
    phone_number: "9000000001",
  },
  {
    uid: "MmbSD51ImkUf3EJubiGklaiid122",
    name: "Priya Singh",
    email: "student2@tap2eat.com",
    role: "student",
    designation: "cs",
    block_name: "B",
    classroom_number: "202",
    phone_number: "9000000002",
  },
  {
    uid: "xlYLBHwkVZaXqhJtrMzcPJwfwhH3",
    name: "Amit Joshi",
    email: "student3@tap2eat.com",
    role: "student",
    designation: "cs",
    block_name: "C",
    classroom_number: "303",
    phone_number: "9000000003",
  },
  {
    uid: "1ICat5S57kNZawok3D7LKeBNz0I3",
    name: "Vikram Rao",
    email: "delivery1@tap2eat.com",
    role: "delivery_student",
    designation: "cs",
    block_name: "A",
    classroom_number: "105",
    phone_number: "9000000004",
  },
  {
    uid: "dFeLLPdy6UTd9CrcmuAFMTF8qlf2",
    name: "Karan Mehta",
    email: "delivery2@tap2eat.com",
    role: "student",
    designation: "cs",
    block_name: "C",
    classroom_number: "6789",
    phone_number: "8888888888",
  },
  {
    uid: "ABM2qkfqTdRPbki9pcJlZc0TZg73",
    name: "teacher tewt",
    email: "teacher@gmail.com",
    role: "teacher",
    designation: "cs",
    block_name: "D",
    classroom_number: "401",
    phone_number: "9000000006",
  },
  {
    uid: "v1cDfrYSpwgN86kUM27FynPmUZt2",
    name: "teacher tewt",
    email: "ttest@gmail.com",
    role: "teacher",
    designation: "cs",
    block_name: "C",
    classroom_number: "6789",
    phone_number: "8888888888",
  },
  {
    uid: "K9NnPA4JfyUP8287kdG9QINsTRa2",
    name: "Suresh Patel",
    email: "canteen1@tap2eat.com",
    role: "canteen_admin",
    block_name: "Main",
    classroom_number: "G01",
    phone_number: "9000000008",
  },
  {
    uid: "AVp3pPe9zxRou51yPfwZSpMurmC3",
    name: "Anita Sharma",
    email: "canteen2@tap2eat.com",
    role: "canteen_admin",
    block_name: "Main",
    classroom_number: "G02",
    phone_number: "9000000009",
  },
  {
    uid: "bldOHE32fDeVi4mRvEtGpAXyU8Q2",
    name: "Dr. Rajesh Kumar",
    email: "master@tap2eat.com",
    role: "master_admin",
    block_name: "Admin",
    classroom_number: "A01",
    phone_number: "9000000010",
  },
];

async function listAllDocuments(token) {
  let allDocs = [];
  let pageToken = null;
  do {
    let url = `${BASE_URL}/users?pageSize=100`;
    if (pageToken) url += `&pageToken=${pageToken}`;
    const res = await httpsRequest(url, {
      method: "GET",
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.status !== 200)
      throw new Error("List failed: " + JSON.stringify(res.data));
    if (res.data.documents) allDocs = allDocs.concat(res.data.documents);
    pageToken = res.data.nextPageToken || null;
  } while (pageToken);
  return allDocs;
}

async function deleteDocument(token, docName) {
  const res = await httpsRequest(
    `https://firestore.googleapis.com/v1/${docName}`,
    { method: "DELETE", headers: { Authorization: `Bearer ${token}` } }
  );
  if (res.status !== 200)
    throw new Error("Delete failed: " + JSON.stringify(res.data));
}

async function createDocument(token, uid, userData) {
  const now = new Date().toISOString();
  const fields = {};
  for (const [key, val] of Object.entries(userData)) {
    fields[key] = firestoreValue(val);
  }
  fields.fcm_tokens = firestoreValue([]);
  fields.created_at = { timestampValue: now };

  const body = JSON.stringify({ fields });
  const url = `${BASE_URL}/users?documentId=${uid}`;
  const res = await httpsRequest(
    url,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    },
    body
  );
  if (res.status !== 200) {
    // Try PATCH if doc already exists
    const patchUrl = `${BASE_URL}/users/${uid}`;
    const patchRes = await httpsRequest(
      patchUrl,
      {
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      },
      body
    );
    if (patchRes.status !== 200) {
      throw new Error(
        `Create/Patch failed for ${uid}: ` + JSON.stringify(patchRes.data)
      );
    }
  }
}

async function main() {
  console.log("=== Tap2Eat User Seed Script ===\n");

  console.log("Getting access token...");
  const token = await getAccessToken();
  console.log("  Authenticated.\n");

  // 1. Delete all existing user documents
  console.log("Step 1: Deleting all documents in 'users' collection...");
  const docs = await listAllDocuments(token);
  for (const doc of docs) {
    const docId = doc.name.split("/").pop();
    await deleteDocument(token, doc.name);
    console.log(`  - Deleted: ${docId}`);
  }
  console.log(`  Deleted ${docs.length} document(s).\n`);

  // 2. Create new user documents
  console.log("Step 2: Creating user documents with new model...");
  for (const user of USERS) {
    const { uid, ...data } = user;
    await createDocument(token, uid, data);
    console.log(`  + ${data.email} (${data.role})`);
  }
  console.log(`\n  Created ${USERS.length} user document(s).`);

  console.log("\nDone! All users now match the new registration model.");
}

main().catch((err) => {
  console.error("Error:", err.message);
  process.exit(1);
});
