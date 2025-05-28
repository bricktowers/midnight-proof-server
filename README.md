# 🧱 Midnight Proof Server with Pre-Baked ZK Params

## 🔍 Motivation

The default `midnightnetwork/proof-server` container attempts to download ZK parameter files from the internet on startup. This behavior can be **unreliable or problematic** in certain contexts due to:

- ⚙️ **Limited or non-interactive environments** like CI/CD pipelines where downloads may silently fail
- 🐞 **Known bug** in the proof server that can cause incomplete or failed downloads
- 📦 **Large file sizes**: some parameter files (e.g., `bls_filecoin_2p24`) can be over **3 GB**

To avoid these issues, this setup allows you to **pre-bake** the required parameter files **into the container image**, ensuring the proof server works reliably in all environments.

---

## 🛠️ How It Works

This setup uses a **multi-stage Docker build**:

1. First stage (`alpine`) downloads the required zk parameter files from S3.
2. Final image (`midnightnetwork/proof-server`) copies the files into `/.cache/midnight/zk-params`.

---

## 🔧 Configuration

### Build Arguments

| Arg Name             | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `PROOF_SERVER_VERSION` | Version of the `midnightnetwork/proof-server` base image (default: `4.0.0`) |
| `CIRCUIT_PARAM_RANGE`  | Space-separated range of circuit IDs to download (e.g., `"10 11 12 13 14 15 16 17"`)          |

> ⚠️ **Note**: Maximum value for circuit param is currently `24`.  
> Circuit `24` file is **~3 GB**, so only include what's needed for your use case.

---

## 🏗️ How to Build

```bash
docker build \
  --build-arg PROOF_SERVER_VERSION=4.0.0 \
  --build-arg CIRCUIT_PARAM_RANGE="10 11 12 13 14 15" \
  -t midnight-proof-server:prebaked .
```

## Alternative: Manual Download + Volume Mount
If you'd rather not bake the files into the image (e.g., to save image size), you can:

Download the files manually:
```bash
./fetch-zk-params.sh
```

Then run the proof server with a volume mount:
```bash
docker run \c
  --name midnight-proof-server \
  -p 6300:6300 \
  -v $(pwd)/.cache/midnight/zk-params:/.cache/midnight/zk-params \
  midnightnetwork/proof-server:4.0.0
```