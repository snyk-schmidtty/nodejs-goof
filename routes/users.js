
var express = require('express')
var dataSource = require('../typeorm-db')

var router = express.Router()
module.exports = router

router.get('/', async (req, res, next) => {

  const repo = dataSource.getRepository("Users")

  // hard-coded getting account id of 1
  // as a rpelacement to getting this from the session and such
  // (just imagine that we implemented auth, etc)
  const results = await repo.find({ where: { id: 1 } })

  // Log Object's where property for debug reasons:
  console.log('The Object.where property is set to: ', {}.where)
  console.log(results)

  return res.json(results)

})

router.post('/', async (req, res, next) => {
  try {
    const repo = dataSource.getRepository("Users")

    const user = {}
    user.name = req.body.name
    user.address = req.body.address
    user.role = req.body.role

    const savedRecord = await repo.save(user)
    console.log("Post has been saved: ", savedRecord)
    return res.sendStatus(200)

  } catch (err) {
    console.error(err)
    console.log({}.where)
    next();
  }
})