# KrakenImage 🐙

KrakenImage 🐙 is a library for downloading images from the web.

## Usage

### Load image from url

```swift
KrakenImageBuilder()
  .url(url)
  .set(to: cell?.photoImageView)
  .load()
```

### Cancel image loading

```swift
KrakenImageBuilder()
  .url(url)
  .set(to: cell?.photoImageView)
  .cancel()
```
