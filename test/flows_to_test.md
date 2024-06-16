## Flows To Test
We currently don't have any integration tests or widget tests to automatically verify the UI and functionality changes. Therefore, the following flows must be tested manually to ensure that all functionalities are working correctly.

### Onboarding
- Import account using Seed Phrase
- Import account using Private Key
- Create account by scanning QR Code
- Create account by following the deeplink

### Wallet
- View transaction details
- Send tokens (search for a user, try changing the denomination)
- Send tokens by scanning QR code
- Receive tokens (share link, check payment status)

### Explore
- Regions
    - Location permission (accept/deny to test)
    - Search for a plan in Map
    - View a region’s details
    - Join a region
    - Create a region (requires 1000 seeds tokens)
- Invite a Friend
    - Share invite
    - Manage invites
- Vouch
    - Vouch someone
    - View thou vouched for you
- Flag
    - View users flagged by you
    - Flag a user
- Vote
    - View open proposals
    - View upcoming proposals
    - View past proposals
    - View specific proposal details
- Plant Seeds
    - Plant specific amount of seeds
- Unplant Seeds
    - Unplant specific amount or max seeds
- Get Seeds

### Profile
- Edit name
- Change currency
- View contribution score
- View progress
- Security
    - Export private key
    - Add Guardians
    - View or copy seed phrase
    - Pin security toggle
    - Biometric auth toggle